class ListingsController < ApplicationController
  def new
    @listing = Listing.new
  end

  def create
    @listing =
      Listing.new(
        listing_params.with_defaults(
          creator: Current.user,
          organization: Current.organization
        )
      )

    if @listing.save
      redirect_to listing_path(@listing),
                  flash: {
                    success: t(".success")
                  },
                  status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  def delete
  end

  private

  def listing_params
    params.require(:listing).permit(:title, :price)
  end
end
