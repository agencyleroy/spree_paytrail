module Spree
  class BillingIntegration::Paytrail::PaytrailCheckout < BillingIntegration
    preference :merchant_id, :string
    preference :merchant_secret, :string
    preference :language, :string, :default => 'EN'
    preference :currency, :string, :default => 'EUR'
    preference :payment_options, :string, :default => 'ACC'

    def provider_class
      ActiveMerchant::Billing::Verkkomaksut
    end

    def redirect_url(order, opts = {})
      opts.merge! self.preferences

      set_global_options(opts)
      set_preferred_language(opts)

      opts[:detail1_text] = order.number
      opts[:detail1_description] = "Order:"

      opts[:pay_from_email] = order.email
      opts[:firstname] = order.bill_address.firstname
      opts[:lastname] = order.bill_address.lastname
      opts[:address] = order.bill_address.address1
      opts[:address2] = order.bill_address.address2
      opts[:phone_number] = order.bill_address.phone.gsub(/\D/,'') if order.bill_address.phone
      opts[:city] = order.bill_address.city
      opts[:zipcode] = order.bill_address.zipcode
      opts[:state] = order.bill_address.state.nil? ? order.bill_address.state_name.to_s : order.bill_address.state.abbr
      opts[:country] = order.bill_address.country.name

      opts[:hide_login] = 1
      opts[:merchant_fields] = 'platform,order_id,payment_method_id'
      opts[:platform] = 'Spree'
      opts[:order_id] = order.number

      opts[:items] = order.line_items.count
      order.line_items.each_with_index do |line_item, index|
        line_item_title = line_item.variant.name
        line_item.variant.option_values.each do |value|
          line_item_title = line_item_title + " / " + value.name
        end
        opts["item_title[#{index}]"] = line_item_title
        opts["item_no[#{index}]"] = line_item.variant.sku
        opts["item_amount[#{index}]"] = line_item.quantity
        opts["item_price[#{index}]"] = line_item.price.to_f
        tax_category = line_item.tax_category
        if tax_category && tax_category.tax_rates
          tax_rates = tax_category.tax_rates
          opts["item_tax[#{index}]"] = (tax_rates.first.amount * 100).to_f
        else
          opts["item_tax[#{index}]"] = 0
        end
      end

      opts[:shipping_costs] = (order.item_total >= 100) ? 0.00 : order.ship_total

      paytrail = self.provider
      paytrail.payment_url(opts)
    end

    private
      def set_global_options(opts)
        opts[:recipient_description] = Spree::Config[:site_name]
        opts[:payment_methods] = self.preferred_payment_options
      end

      def set_preferred_language(opts)
        # if self.preferred_language == "en_US"
        #   lang = "en_US"
        # elsif self.preferred_language.downcase == "en"
        #   lang = "en_US"
        # elsif self.preferred_language.downcase == "fi"
        #   lang = "fi_FI"
        # elsif self.preferred_language == "fi_FI"
        #   lang = "fi_FI"
        # else
        #   lang = "en_US"
        # end
        if I18n.locale.to_s == "en"
          lang = "en_US"
        elsif I18n.locale.to_s == "fi"
          lang = "fi_FI"
        else
          lang = "fi_FI"
        end

        opts[:culture] = lang
      end
  end
end
