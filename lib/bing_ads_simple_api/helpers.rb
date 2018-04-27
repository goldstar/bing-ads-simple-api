module BingAdsSimpleApi
  module Helpers
    module ClassAndInstanceMethods

      def camelize(stringy)
        stringy.to_s.split('_').collect(&:capitalize).join
      end


      def tns(obj)
        if obj.is_a?(Hash)
          obj.to_a.map{ |k,v|
            k = tns(k)
            v = tns(v) if v.is_a?(Hash) || v.is_a?(Array) || v.is_a?(Date)
            [ k,v ]
          }.to_h
        elsif obj.is_a?(Array)
          obj.to_a.map{ |x| x.is_a?(Hash) ? tns(x) : x }
        elsif obj.is_a?(Date)
          {
            day: obj.day,
            month: obj.month,
            year: obj.year
          }
        elsif obj.is_a?(Symbol)
          "tns:#{camelize(obj)}"
        else
          obj
        end
      end

      def dig(hash, symbol)
        hash.each_pair do |k,v|
          return v if k == symbol
          if v.is_a?(Hash)
            found = dig(v, symbol)
            if found
              return found
            end
          end
        end
        nil
      end
    end
    
    def self.included(receiver)
      receiver.extend         ClassAndInstanceMethods
      receiver.send :include, ClassAndInstanceMethods
    end
  end
end
