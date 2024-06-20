class AuditsController < ApplicationController
    layout "audits"
    before_action :set_survey, only: %i[index save_answers]

    def index
        @step = params[:step].to_i
        set_log

        @log.update!(status: 1) if @log.deafult?
        @log.update!(status: 2) unless @step.zero?
        @total = @survey.sections.count
    end

    def finish
        set_log

        @log.update!(status: 3) if @log.process?
        @survey = Survey.find(params[:id])
    end

    def save_answers
        @ids = params[:question][:ids].reject { |key, value| value.empty? }

        @ids.each do |key, value|

            @answers = Answe.find_by(question_id: key, user_token: params[:user_token])
            
            if @answers.nil?
                Answe.create!(name: value, question_id: key, 
                             user_token: params[:user_token], survey_id: @survey.id )
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

    def set_log
        @token = params[:token_id]
        @log = Log.find_by(token: @token)
        redirect_to root_path if @log.finish?
    end
end
