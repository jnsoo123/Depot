#require 'rails_helper'
#
#describe 'store/index.html.erb', type: :view do
#  before(:each) do
#    @products = mock_model(Product)  
#  end
#  
#  it 'displays an empty catalog' do
##    assign(:products, double("products", empty?: true, each: {id: 1, title: "test"}, total_pages: 1 ) )
#    @products.stub(empty?: true)
#    @products.stub(each: nil)
#    @products.stub(total_pages: 1)
#    render template: 'store/index', layout: 'layouts/application'
#    expect(rendered).to include('No Results Found!')
#  end
#  
#  it 'displays a catalog' do
#    assign(:products, double("products", empty?: false, each: {id: 1, title: "test"}, total_pages: 1 ) )
#    render template: 'store/index', layout: 'layouts/application'
#    expect(rendered).not_to include('No Results Found!')
#  end
#end