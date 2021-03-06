class Web::TasksController < Web::ApplicationController
  add_breadcrumb {{ url: tasks_path }}

  def index
    authorize :task
    filter = { status_in: 'active' }.merge(params.fetch(:q, {}))
    @q = policy_scope(Task).search(filter)
    @q.sorts = 'id desc' if @q.sorts.empty?
    @tasks = @q.result(distinct: true).page(params[:page])
    respond_with @tasks
  end

  def show
    @task = Task.find params[:id]
    authorize @task
    add_breadcrumb model: @task
    respond_with @task
  end

  def new
    @task_type = TaskType.new
    @task_type.creator = current_user
    @task_type.actor = current_user
    authorize @task_type
    add_breadcrumb
    respond_with @task_type
  end

  def create
    @task_type = TaskType.new
    @task_type.creator = current_user
    @task_type.actor = current_user
    authorize @task_type
    add_breadcrumb
    @task_type.update task_params
    TaskNotificationService.on_create(@task_type)
    respond_with @task_type
  end

  def edit
    @task_type = TaskType.find params[:id]
    @task_type.actor = current_user
    authorize @task_type
    add_breadcrumb model: @task_type
    respond_with @task_type
  end

  def update
    @task_type = TaskType.find params[:id]
    @task_type.actor = current_user
    authorize @task_type
    add_breadcrumb model: @task_type
    @task_type.update task_params
    respond_with @task_type
  end

  def status
    @task_type = TaskType.find params[:id]
    @task_type.actor = current_user
    authorize @task_type
    @task_type.update status_event: params[:event]
    respond_with @task_type
  end

  private

  def task_params
    attrs = policy(@task_type).permitted_attributes
    params.require(:task).permit(attrs)
  end

end
