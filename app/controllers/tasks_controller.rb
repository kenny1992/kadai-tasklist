class TasksController < ApplicationController
    before_action :require_user_logged_in, only: [:index, :show]
    before_action :correct_user, only: [:show,:edit,:destroy]
    
    def index
        @tasks=current_user.tasks.page(params[:page])
    end
    
    def show
        @task=Task.find(params[:id])
    end
    
    def new
        @task=current_user.tasks.build
    end
    
    def create
        @task= current_user.tasks.build(task_params)
        
        if @task.save
           flash[:success] = 'Task が正常に作成されました'
           redirect_to tasks_url
        else
           @tasks = current_user.tasks.order(id: :desc).page(params[:page])
           flash.now[:danger] = 'Task が作成されませんでした'
           render 'tasks/index'
        end
    end
    
    def edit
        @task=Task.find(params[:id])
    end
    
    def update
        @task=Task.find(params[:id])
        
        if @task.update(task_params)
           flash[:success] = 'Task は正常に更新されました'
           redirect_to @task
        else
           flash.now[:danger] = 'Taskは更新されませんでした'
           render :edit
        end
    end
    
    def destroy
        @task.destroy

        flash[:success] = 'Task は正常に削除されました'
        redirect_back(fallback_location: root_path)
    end

private
  # Strong Parameter
    def task_params
    params.require(:task).permit(:content,:status)
    end
    
    def correct_user
        @task = current_user.tasks.find_by(id: params[:id])
        unless @task
        redirect_to tasks_path
        end
    end
end