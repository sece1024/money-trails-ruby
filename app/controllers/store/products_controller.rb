class Store::ProductsController < Store::BaseController
  before_action :set_product, only: %i[ show edit update destroy ]

  def index
    @products = Product.all
  end

  def show
  end

  def edit
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to store_product_path(@product), notice: "Product has been created"
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to store_product_path(@product)
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @product.destroy
    redirect_to store_products_path, status: :see_other, notice: "Product has been deleted"
  end

  private
  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.expect(product: [ :name, :description, :featured_image, :inventory_count ])
  end
end
