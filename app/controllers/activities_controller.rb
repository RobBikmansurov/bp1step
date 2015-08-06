class ActivitiesController < ApplicationController
  def index
    @activities_header = ''
    if params[:type].present?
      @activities = PublicActivity::Activity.where(trackable_type: "#{params[:type]}")
      if params[:id].present?
        case params[:type].downcase
        when 'letter'
          letter = Letter.find("#{params[:id]}")
          @activities_header = "Письмо #{letter.name}"
          ids = PublicActivity::Activity.select(:id).where(trackable_type: "#{params[:type]}", trackable_id: "#{params[:id]}") \
            | PublicActivity::Activity.select(:id).where(trackable_type: "UserLetter", trackable_id: letter.user_letter.ids) \
            | PublicActivity::Activity.select(:id).where(trackable_type: "LetterAppendix", trackable_id: letter.letter_appendix.ids)
          @activities = PublicActivity::Activity.where(id: ids).order("created_at desc")
        else
          @activities = PublicActivity::Activity.where(trackable_type: "#{params[:type]}", trackable_id: "#{params[:id]}")
        end
      end
    else
      @activities = PublicActivity::Activity.order("created_at desc")
    end
    @activities = @activities.paginate(:per_page => 100, :page => params[:page])
  end
end
