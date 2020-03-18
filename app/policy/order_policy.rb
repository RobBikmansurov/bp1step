# frozen_string_literal: true

# policy for orders actions
class OrderPolicy
  def initialize; end

  def process_id
    Rails.configuration.x.dms.process_ko # id процесса ЭДО. Распоряжения в электронном виде
  end

  def able_to_approve?(user, order)
    order.status == 'Новое' && (user.executor_of? process_id, 'Руководитель')
  end

  def able_to_complete?(user, order)
    order.status == 'Согласовано' && (user.executor_of? process_id, 'Исполнитель')
  end

  def able_to_delete?(user, order)
    order.status == 'Новое' && user.id == order.author_id
  end

  def able_back_from_approved?(user, order)
    order.status == 'Согласовано' && order.manager_id == user.id
  end

  def able_back_from_completed?(user, order)
    order.status == 'Исполнено' && order.executor_id == user.id
  end

  def allowed?(user)
    user.executor_in? process_id
  end
end
