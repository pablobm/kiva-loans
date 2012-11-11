class Loan

  attr_reader :lender_id, :lender_name, :lender_location,
              :borrower_name, :borrower_town, :borrower_country

  def initialize(data)
    @lender_id = data['lender']['lender_id']
    @lender_name = data['lender']['name']
    @lender_location = data['lender']['whereabouts']
    @borrower_name = data['loan']['name']
    @borrower_town = data['loan']['location']['town']
    @borrower_country = data['loan']['location']['country']
  end

  def lender_url
    '/' + @lender_id.to_s
  end

end
