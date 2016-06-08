class Lead < ActiveRecord::Base

# ###############################################################################
# Relationship betweer User & Lead, through Order
# ###############################################################################
  has_many :reverse_orders, foreign_key: "selected_id",
                                   class_name: "Order",
                                   dependent: :destroy
  has_many :selectors, through: :reverse_orders, source: :selector
  belongs_to :user
  attr_writer :current_step

  # :::::::::::::: VALIDATIONS :::::::::::::::::::

  validates :description, presence: true
  validates :business_type, presence: true
  validates :address, presence: true
  validates :name, presence: true
  validates :email, presence: true, format: {with: /.+@.+\..+/i}



  # :::::::::::::: LEAD/NEW forms :::::::::::::::::::

  def current_step
    @current_step || steps.first
  end

  def steps
    if business_type == "#{I18n.t'lead-new.form.business-types.building_house'}"
      %w[first building]
    elsif business_type == "#{I18n.t'lead-new.form.business-types.architect'}"
      %w[first architect]
    elsif business_type == "#{I18n.t'lead-new.form.business-types.masonry'}"
      %w[first masonry]
    elsif business_type == "#{I18n.t'lead-new.form.business-types.renovation'}"
      %w[first renovation]
    elsif business_type == "#{I18n.t'lead-new.form.business-types.mechanical_installations'}"
      %w[first mechanical_installations]
    elsif business_type == "#{I18n.t'lead-new.form.business-types.electrical_installations'}"
      %w[first electrical_installations]
    elsif business_type == "#{I18n.t'lead-new.form.business-types.painting'}"
      %w[first painting]
    elsif business_type == "#{I18n.t'lead-new.form.business-types.fasades'}"
      %w[first fasades]
    elsif business_type == "#{I18n.t'lead-new.form.business-types.roofing'}"
      %w[first roofing]
    else
      %w[first second]
    end
  end

  def next_step
    self.current_step = steps[steps.index(current_step)+1]
  end

  def previous_step
    self.current_step = steps[steps.index(current_step)-1]
  end

  def first_step?
    current_step == steps.first
  end

  def last_step?
    current_step == steps.last
  end

end
