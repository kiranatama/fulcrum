class SettingsController < Devise::RegistrationsController

  def edit
    @user = current_user
    render_with_scope :edit, 'devise/registrations'
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    if resource.update_attributes(params[:user])
      set_flash_message :notice, :updated if is_navigational_format?
      sign_in resource_name, resource, :bypass => true
      respond_with resource, :location => after_update_path_for(resource)
    else
      render_with_scope :edit, 'devise/registrations'
    end
  end
end
