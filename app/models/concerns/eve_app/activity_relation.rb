module EveApp::ActivityRelation
  extend ActiveSupport::Concern

  included do
    belongs_to :type
    belongs_to :activity

    EveApp::Activity::TYPE_MAP.each do |id, type|
      scope type, -> { where(activity_id: id) }
    end
  end

  # included do
    # scope :invention, -> { where(activity_id: EveApp::Activity::INVENTION) }
    # scope :for, -> (tid, aid) { where(type_id: tid, activity_id: aid) }
    # ????
    # def activity_activity
    #   EveApp::Activity.where(type_id: type_id, activity_id: activity_id)
    # end
  # end

  # class_methods do
  #   def type_name
  #     reflections = self.reflect_on_all_associations(:belongs_to)
  #     reflections.select { |r| r.options[:class_name] == 'Type' && r.name != :type }.first.name
  #   end
  # end
end
