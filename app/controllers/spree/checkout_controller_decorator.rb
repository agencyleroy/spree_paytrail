module Spree
  CheckoutController.class_eval do
    before_filter :confirm_paytrail, :only => [:update]

    # TODO: Add banks and map them to payment_method_id
    # BANKS = ['nordea', 'aktia']

    def success?(params)
      params['PAID'] != "0000000000"
    end

    def acknowledge(authcode)
      return_authcode = [params["ORDER_NUMBER"], params["TIMESTAMP"], params["PAID"], params["METHOD"], authcode].join("|")
      Digest::MD5.hexdigest(return_authcode).upcase == params["RETURN_AUTHCODE"]
    end

    def secret
      # Defined in admin interface
      Spree::BillingIntegration::Paytrail::PaytrailCheckout.first.preferences[:merchant_secret]
    end

    def paytrail_return
      # Create new payment if no payment already exists
      unless @order.payments.where(:source_type => 'Spree::PaytrailTransaction').present?
        payment_method = PaymentMethod.find(params[:payment_method_id])
        paytrail_transaction = PaytrailTransaction.new
        payment = @order.payments.create({:amount => @order.total,
                                         :source => paytrail_transaction,
                                         :payment_method => payment_method})
        payment.started_processing!
        payment.pend!
      end

      payment_method = PaymentMethod.find(params[:payment_method_id])
      payment = @order.payments.where(:state => "pending",
                                      :payment_method_id => payment_method).first

      unless payment
        payment_method = PaymentMethod.find(params[:payment_method_id])
        paytrail_transaction = PaytrailTransaction.new
        payment = @order.payments.create({:amount => @order.total,
                                         :source => paytrail_transaction,
                                         :payment_method => payment_method})
        # Added Oct 7 in an attempt to track missing payments
        payment.started_processing!
        payment.pend!
      end

      # Check if the auth-code returned from Paytrail is valid
      if success?(params) == false || acknowledge(secret) == false
        logger.error "Payment wasn't valid for order: #{@order.number}"
        flash[:notice] = "There was a problem with authorizing your payment."
        payment.started_processing!
        payment.failure!
        redirect_to checkout_state_path(@order.state)
      else
        payment.complete!
        @order.finalize!
        @order.update!
        @order.state = "complete"
        @order.save!
      end

      if @order.state == "complete" || @order.completed?
        flash[:notice] = I18n.t(:order_processed_successfully)
        flash[:commerce_tracking] = "nothing special"
        #if params[:payment_method_id].to_i == 6
        render :partial => "jsredirect", :locals => {:route => completion_route}
        #else
        #  redirect_to completion_route
        #end
      else
        logger.error "@order wasn't complete for #{@order.number}"
        redirect_to checkout_state_path(@order.state)
      end
    end

    def paytrail_cancel
      flash[:error] = t(:payment_has_been_cancelled)
      render :partial => "jsredirect", :locals => {:route => edit_order_path(@order)}
    end

    private

    def confirm_paytrail
      return unless (params[:state] == "payment") && params[:order][:payments_attributes]

      payment_method = PaymentMethod.find(params[:order][:payments_attributes].first[:payment_method_id])
      if payment_method.kind_of?(BillingIntegration::Paytrail::PaytrailCheckout)
        #TODO confirming payment method
        redirect_to edit_order_checkout_url(@order, :state => 'payment'),
                    :notice => t(:complete_skrill_checkout)
      end
    end
  end
end
