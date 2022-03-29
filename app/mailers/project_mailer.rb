class ProjectMailer < ApplicationMailer
    def project_created
        @project = params[:project]
        @creator = @project.creator.email
        @client = @project.client.email
        @recipients = "#{@creator},#{@client}"
        mail(to: @recipients, subject: "Your Project created successfully")
    end
end
