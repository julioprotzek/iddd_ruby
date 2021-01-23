# Basic messaging error
class MessageError < RuntimeError
  attr_reader :message, :backtrace

  def initialize(message:, cause: nil, should_retry: false)
    pp
    @message = message
    @cause = cause
    @should_retry = should_retry

    if cause.present?
      @message = @message + "\n" + cause.message
      @backtrace = cause.backtrace if cause.present?
    end
  end

  # Answers whether or not retry is set. Retry can be used by MessageListener
  # when it wants the message it has attempted to handle to be re-queued
  # rather than rejected, so that it can re-attempt handling later.
  def retry?
    @should_retry
  end
end