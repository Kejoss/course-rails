class AuditsController < ApplicationController
    layout "audits"
    before_action :set_survey, only: %i[index]

    def index
        @token = params[:token_id]
        @step = params[:step].to_i
        @total = @survey.sections.count
    end

    def finish
        @survey = Survey.find(params[:id])
    end

    def save_answers
        @ids = params[:question][:ids].reject { |key, value| value.empty? }

        @ids.each do |key, value|

            @answers = Answe.find_by(question_id: key, user_token: params[:user_token])
            
            if @answers.nil?
                Answe.create!(name: value, question_id: key, user_token: params[:user_token])
            else
                @answers.update!(name: value)
            end
        end
    end

    private 


    def set_survey
        @survey = Survey.find_by(uuid: params[:id])
        redirect_to root_path if @survey.nil?
    end
end
