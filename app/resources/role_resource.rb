# frozen_string_literal: true

#  Copyright (c) 2022, Schweizer Wanderwege. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

class RoleResource < ApplicationResource
  # read-only for now
  with_options writable: false do
    attribute :person_id, :integer
    attribute :group_id, :integer
    attribute :label, :string
    attribute :created_at, :datetime
    attribute :updated_at, :datetime
    attribute :deleted_at, :datetime
  end

  def index_ability
    IndexAbilityCache.index_ability(current_ability)
  end

  private

  # building the `JsonApi::ContactAbility` as currently implemented is very expensive.
  # we cache it so it can be used from the other instances of this resource.
  class IndexAbilityCache < ActiveSupport::CurrentAttributes
    attribute :cache

    def index_ability(main_ability)
      self.cache ||= {}
      self.cache[main_ability.user] ||= contact_ability(main_ability)
    end

    private

    def contact_ability(main_ability)
      JsonApi::RoleAbility.new(main_ability, people_scope(main_ability.user))
    end

    def people_scope(user)
      Person.accessible_by(PersonReadables.new(user))
    end
  end
end
