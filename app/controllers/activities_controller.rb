# frozen_string_literal: true

class ActivitiesController < ApplicationController
  def index
    @activities_header = ''
    if params[:type].present?
      @activities = PublicActivity::Activity.where(trackable_type: params[:type].to_s)
      if params[:id].present?
        case params[:type].downcase
        when 'letter'
          letter = Letter.find(params[:id].to_s)
          @activities_header = "Письмо #{letter.name}"
          ids = PublicActivity::Activity.select(:id).where(trackable_type: params[:type].to_s, trackable_id: params[:id].to_s) \
            | PublicActivity::Activity.select(:id).where(trackable_type: 'UserLetter', trackable_id: letter.user_letter.ids) \
            | PublicActivity::Activity.select(:id).where(trackable_type: 'LetterAppendix', trackable_id: letter.letter_appendix.ids)
          @activities = PublicActivity::Activity.where(id: ids).order('created_at desc')
        when 'contract'
          contract = Contract.find(params[:id].to_s)
          @activities_header = "Договор #{contract.shortname}"
          ids = PublicActivity::Activity.select(:id).where(trackable_type: params[:type].to_s, trackable_id: params[:id].to_s) \
            | PublicActivity::Activity.select(:id)
                                      .where(trackable_type: 'ContractScan', trackable_id: contract.contract_scan.ids) \
            | PublicActivity::Activity.select(:id)
                                      .where(trackable_type: 'BproceContract', trackable_id: contract.bproce_contract.ids)
          @activities = PublicActivity::Activity.where(id: ids).order('created_at desc')
        else
          @activities = PublicActivity::Activity.where(trackable_type: params[:type].to_s, trackable_id: params[:id].to_s)
        end
      end
    else
      @activities = PublicActivity::Activity.order('created_at desc')
    end
    @activities = @activities.paginate(per_page: 100, page: params[:page])
  end
end
