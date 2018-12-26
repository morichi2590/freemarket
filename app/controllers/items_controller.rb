class ItemsController < ApplicationController

  before_action :set_category_brand, except: [:new, :create]

  def index
    @item = Item.order("RAND()")
    @items = Item.new
    @categorys = Category.where(parent_id: nil)
    @brands = Brand.order("created_at DESC")
  end

  def new
    @item = Item.new
    4.times {@item.images.build}
    render :new, layout: "sub-layout"
  end

  def show
  	@item = Item.find(params[:id])
    @user = @item.user
  end

  def create
    @item =Item.new(exhibit_params)
    @item.save
  end

  def destroy
    item = Item.find(params[:id])
    if item.user_id == current_user.id
      if item.destroy
        redirect_to root_path notice:'削除できました'
      else
        redirect_to root_path notice: 'エラーが発生しました。'
      end
    end
  end

  private
  def exhibit_params
    params[:item].permit(:name,:description,:condition_id,:postage_id,:delivery_method_id,:prefecture_id,:delivery_day_id,:price,:category_id,images_attributes:[:id,:image]).merge(user_id:current_user.id)
  end

  def set_category_brand
    @categorys = Category.where(parent_id: nil)
    @brands = Brand.order("created_at DESC")
  end
end



