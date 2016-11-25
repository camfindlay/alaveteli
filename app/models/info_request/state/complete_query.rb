# -*- encoding : utf-8 -*-
class InfoRequest
  module State
    class CompleteQuery
      def initialize(relation = InfoRequest)
        @relation = relation
      end

      def call
        @relation.where(described_state: ['not_held',
                                          'rejected',
                                          'successful',
                                          'partially_successful',
                                          'user_withdrawn'])
      end
    end
  end
end
