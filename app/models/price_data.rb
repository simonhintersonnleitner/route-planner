class PriceData < ActiveRecord::Base

  def self.get_cheaptest_diesel_price
    min = self.minimum(:minDiesel)
    return self.where(minDiesel: min).take
  end
  def self.get_cheaptest_petrol_price
    min = self.minimum(:minPetrol)
    return self.where(minPetrol: min).take
  end
  def self.get_priciest_diesel_price
    max = self.maximum(:minDiesel)
    return self.where(minDiesel: max).take
  end
   def self.get_priciest_petrol_price
    max = self.maximum(:minPetrol)
    return self.where(minPetrol: max).take
  end
end


