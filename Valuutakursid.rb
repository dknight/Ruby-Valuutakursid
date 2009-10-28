# Takes data from Estonian bank and gets the freshest money rates or archieve data
#
# Author::    Dmitri Smirnov, http://www.dmitri.me/  (mailto:dmitri@dmiti.me)
# Copyright:: Copyright (c) 2009 Dmitri Smirnov
# License::   MIT

# = Usage
# Valuutakursid.new([string date], [string currency_index])
#
# R = Valuutakursid.new('27.10.2009')
# rates = R.get_data
# puts rates
# puts rates['EUR']

require 'open-uri'
require 'csv'

class Valuutakursid

  # Date must be in Estonian format %d.%m.%y
  def initialize(date)
    @date     = date || Time.now.strftime('%d.%m.%Y')
    @cache    = nil #cache avoid multiple requests
  end

  # Retrives data from Estonian bank
  def get_data
    
    # If first run cache do request else return cache
    if @cache.nil?
      retval = {}
      
      date = @date.split('.')
      day   = date[0].to_i
      month = date[1].to_i
      year  = date[2].to_i
      
      indexes = 
            /^(|ARS|AZN|AUD|BGN|BRL|BYR|CAD|CHF|CNY|CZK|DKK|EGP|EUR|
            GBP|GEL|HKD|HRK|HUF|IDR|ILS|INR|ISK|JPY|KGS|KRW|KZT|LTL|LVL|
            MAD|MDL|MXN|MYR|NOK|NZD|PLN|RON|RSD|RUB|SDR|SEK|SGD|SKK|ZAR|
            THB|TND|TRY|TWD|UAH|USD|UZS|VEF|XAU|XOF)$/

      #Estonian Bank URL, data updates there everyday at 13:00 EET
      url  = 'http://www.eestipank.info/dynamic/erp/erp_csv.jsp'
      path = "?day=#{day}&month=#{month}&year=#{year}&type=4&lang=et"
  
      open(url + path) do |f|
  
        #clean the string, and 160.chr is strange whitespace, enspace or emspace?
        data = f.read.gsub("\"", '').gsub(160.chr, '').gsub(',', '.')
       
        CSV.parse(data, ';') do |row|
          row[0] = row[0].to_s
          row[1] = row[1].to_f
          retval[row[0]] = row[1]
        end
      end
      
      @cache = retval
      retval
    else
      @cache
    end
    
  end

end 

