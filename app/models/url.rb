class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || "must be a valid URL") unless url_valid?(value)    
  end

  # a URL may be technically well-formed but may 
  # not actually be valid, so this checks for both.
  def url_valid?(url)
    url = URI.parse(url) rescue false
    url.kind_of?(URI::HTTP) || url.kind_of?(URI::HTTPS)
  end 
end

class Url < ActiveRecord::Base
  belongs_to :user
  validates :long_url, url: true, :uniqueness => true

  def create_short_url
    self.update_attribute(:short_url, SecureRandom.hex(3))
    self
  end

  def increment_click_count
    self.click_count += 1
    self.save
  end
end
