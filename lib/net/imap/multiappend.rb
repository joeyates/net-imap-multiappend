# frozen_string_literal: true

require "net/imap"

class Net::IMAP
  module Multiappend
    REQUIRED_CAPABILITIES = %w(LITERAL+ MULTIAPPEND).freeze

    def multiappend(mailbox, messages)
      args = ([[]] + messages).reduce do |memo, (message, flags, date_time)|
        memo.push(flags) if flags
        memo.push(date_time) if date_time
        literal = Literal.new(message)
        memo.push(literal)
        memo
      end
      send_command("APPEND", mailbox, *args)
    end

    def can_multiappend?
      capabilities = capability
      REQUIRED_CAPABILITIES.all? { |c| capabilities.include?(c) }
    end
  end

  include Multiappend
end
