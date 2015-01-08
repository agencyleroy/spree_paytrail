module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class Verkkomaksut < Gateway

      def fields(opts)
        hash = {
          TYPE: "E1",
          MERCHANT_ID: opts[:merchant_id],
          ORDER_NUMBER: opts[:order_id],
          REFERENCE_NUMBER: "",
          ORDER_DESCRIPTION: opts[:description],
          RETURN_ADDRESS: opts[:return_url],
          CANCEL_ADDRESS: opts[:cancel_url],
          PENDING_ADDRESS: "",
          NOTIFY_ADDRESS: "",
          CULTURE: opts[:culture],
          PRESELECTED_METHOD: "",
          MODE: 1,
          VISIBLE_METHODS: "",
          GROUP: "",
          CURRENCY: opts[:currency],
          CONTACT_TELNO: opts[:phone_number],
          CONTACT_CELLNO: "",
          CONTACT_EMAIL: opts[:pay_from_email],
          CONTACT_FIRSTNAME: opts[:firstname],
          CONTACT_LASTNAME: opts[:lastname],
          CONTACT_COMPANY: "",
          CONTACT_ADDR_STREET: opts[:address],
          CONTACT_ADDR_ZIP: opts[:zipcode],
          CONTACT_ADDR_CITY: opts[:city],
          CONTACT_ADDR_COUNTRY: "FI",
          INCLUDE_VAT: 1,
          ITEMS: opts[:items],
        }
        for index in 0..opts[:items]-1 do
          hash[:"ITEM_TITLE[#{index}]"] = opts["item_title[#{index}]"]
          hash[:"ITEM_NO[#{index}]"] = opts["item_no[#{index}]"]
          hash[:"ITEM_AMOUNT[#{index}]"] = opts["item_amount[#{index}]"]
          hash[:"ITEM_PRICE[#{index}]"] = opts["item_price[#{index}]"]
          hash[:"ITEM_TAX[#{index}]"] = opts["item_tax[#{index}]"]
          hash[:"ITEM_DISCOUNT[#{index}]"] = 0
          hash[:"ITEM_TYPE[#{index}]"] = 1
        end
        puts YAML::dump(hash)
        return hash
      end

      def service_url
        "https://payment.paytrail.com/"
      end

      def payment_url(opts)
        post = PostData.new
        post.merge! fields(opts)
        post.merge!(AUTHCODE: generate_md5string(fields(opts), opts[:merchant_secret]))

        "#{service_url}?#{post.to_s}"
      end

      # Calculates the AUTHCODE
      def generate_md5string(data, secret)
        fields = [secret,
                  data[:MERCHANT_ID],
                  data[:ORDER_NUMBER],
                  data[:REFERENCE_NUMBER],
                  data[:ORDER_DESCRIPTION],
                  data[:CURRENCY],
                  data[:RETURN_ADDRESS],
                  data[:CANCEL_ADDRESS],
                  data[:PENDING_ADDRESS],
                  data[:NOTIFY_ADDRESS],
                  data[:TYPE],
                  data[:CULTURE],
                  data[:PRESELECTED_METHOD],
                  data[:MODE],
                  data[:VISIBLE_METHODS],
                  data[:GROUP],
                  data[:CONTACT_TELNO],
                  data[:CONTACT_CELLNO],
                  data[:CONTACT_EMAIL],
                  data[:CONTACT_FIRSTNAME],
                  data[:CONTACT_LASTNAME],
                  data[:CONTACT_COMPANY],
                  data[:CONTACT_ADDR_STREET],
                  data[:CONTACT_ADDR_ZIP],
                  data[:CONTACT_ADDR_CITY],
                  data[:CONTACT_ADDR_COUNTRY],
                  data[:INCLUDE_VAT],
                  data[:ITEMS]]
        for index in 0..data[:ITEMS]-1 do
          fields.append(data[:"ITEM_TITLE[#{index}]"])
          fields.append(data[:"ITEM_NO[#{index}]"])
          fields.append(data[:"ITEM_AMOUNT[#{index}]"])
          fields.append(data[:"ITEM_PRICE[#{index}]"])
          fields.append(data[:"ITEM_TAX[#{index}]"])
          fields.append(data[:"ITEM_DISCOUNT[#{index}]"])
          fields.append(data[:"ITEM_TYPE[#{index}]"])
        end

        fields = fields.join("|")
        return Digest::MD5.hexdigest(fields).upcase.to_s
      end

    end
  end
end
