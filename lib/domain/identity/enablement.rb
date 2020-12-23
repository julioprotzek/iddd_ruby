class Enablement
  include Assertion

  attr_reader :enabled, :start_at, :end_at

  def self.indefinite_enablement
    Enablement.new(enabled: true)
  end

  def initialize(enabled: false, start_at: nil, end_at: nil)
    if start_at.present? || end_at.present?
      assert_presence_kind_of(start_at, Date, 'The start date must be provided.')
      assert_presence_kind_of(end_at, Date, 'The end date must be provided.')
      assert(start_at < end_at, 'Enablement start and/or end date is invalid.')
    end

    @enabled = enabled
    @start_at = start_at
    @end_at = end_at
  end

  def enabled?
    @enabled
  end

  def enablement_enabled?
    enabled? && !time_expired?
  end

  def time_expired?
    @start_at.present? && @end_at.present? && !Time.now.between?(@start_at, @end_at)
  end

  def ==(other)
    self.class == other.class &&
    self.enabled? == other.enabled? &&
    self.start_at == other.start_at &&
    self.end_at == other.end_at
  end
end