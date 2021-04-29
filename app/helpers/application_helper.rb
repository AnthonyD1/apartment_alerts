module ApplicationHelper
  BOOTSTRAP_FLASH_MSG = {
    error: 'danger',
    alert: 'warning',
    notice: 'info'
  }

  def bootstrap_class_for(flash_type)
    BOOTSTRAP_FLASH_MSG.fetch(flash_type.to_sym, flash_type.to_s)
  end
end
