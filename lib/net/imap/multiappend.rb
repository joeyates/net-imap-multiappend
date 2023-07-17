# frozen_string_literal: true

require "net/imap"

class Net::IMAP
  module Multiappend
    REQUIRED_CAPABILITIES = %w(LITERAL+ MULTIAPPEND).freeze

    class Message
      attr_reader :message
      attr_reader :flags
      attr_reader :date_time

      def initialize(message, flags: nil, date_time: nil)
        @message = message
        @flags = flags
        @date_time = date_time
      end

      def message_literal
        Literal.new(message)
      end
    end

    def multiappend(mailbox, messages)
      args = ([[]] + messages).reduce do |memo, m|
        memo.push(m.flags) if m.flags
        memo.push(m.date_time) if m.date_time
        memo.push(m.message_literal)
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
