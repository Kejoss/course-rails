class SurveySection < ApplicationRecord
  belongs_to :survey
  belongs_to :section

  before_create :configure_order

  private

  def self.check_no_repeat_records(survey, ids, new_ids)
    survey_sections = where(survey_id: survey.id)
    ids.each{ |id| new_ids << id.to_i unless survey_sections.find_by(section_id: id).present? }


    new_ids
  end

  def configure_order
    surv_sec = SurveySection.where(survey_id: survey.id).order(order: :asc)

    surv_sec.empty? ? self.order = 1 : self.order = surv_sec.last.order + 1
  end

  def reorder_objects(id)
    survey_sections = where(survey_id: survey.id)

    survey_sections.each.with_index do |survey_section, index|
      survey_section.update!(order: index + 1 )
    end
  end
end
