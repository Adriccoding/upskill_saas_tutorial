class ContactsController < ApplicationController
    
    #GET request to /contact-us
    #Show new contact form
    def new
      @contact = Contact.new
    end
    
    # Post request /contact
    def create
      # Mass assignment of form feilds into contact object
      @contact = Contact.new(contact_params)
      # Save the contact object to the database
      if @contact.save
          # Store form fields via parameters, into variables
          name = params[:contact][:name]
          email = params[:contact][:email]
          body = params[:contact][:comments]
          # Plug variable into ContactMailer email method and send email
          ContactMailer.contact_email(name, email, body).deliver
          #Store sucess message in flash hash and redirect to new action
         flash[:success] = "Message sent."
         redirect_to new_contact_path
      else
          #if not save, store erros in flash has and redirect new action
         flash[:danger] = @contact.errors.full_messages.join(", ")
         redirect_to new_contact_path
      end
    end
    
    private
      # To collect data from form we need to use strong parameter
      # and whitelist form fields
      def contact_params
         params.require(:contact).permit(:name, :email, :comments)
      end
end