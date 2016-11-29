# -*- encoding : utf-8 -*-
class InfoRequest
  module State
    class AwaitingResponseQuery
      def initialize(relation = InfoRequest)
        @relation = relation
      end

      def call
        @relation.where(described_state: 'waiting_response')
      end
    end
  end
end