# Ariel Diamond ThoughtWorks Application
# Sales Tax Problem in Ruby

# I created two objects: Products and Receipts. Products contain all of the information for individual products, and Receipts calls on that information. 
# The output will run as desired on the command line.
# One scalability issue is the category variable -- if many more products are added, the method for setting the category will have to be changed, since a simple string search will quickly become unwieldy.
# Note: One of the output prices in the original problem seems to be incorrect: imported tax should round up to the nearest $0.05, but the second bottle of imported perfume has an output price of $32.19. I believe this should be $32.20. This accounts for the $0.01 difference in output 3.

# Initialize Product
class Product
	attr_reader :name, :price, :quantity, :imported, :category, :tax_rate, :receipt_output

	def initialize(args)
		@name = args[:name]
		@price = args[:price]
		@quantity = args[:quantity]
		@imported = args[:imported] || false
		@category = args[:category]
	end

	def imported?
		@imported == false ? false : true
	end

	def tax_class
		if imported? && (@category == 'books' || @category == 'food' || @category == 'medical')
			@tax_rate = 1.05
		elsif imported?
			@tax_rate = 1.15
		elsif @category == 'books' || @category == 'food' || @category == 'medical'
			@tax_rate = 1
		else
			@tax_rate = 1.1
		end
		return @tax_rate.to_f
	end

	def price_with_tax 
		@pwt = (tax_class * @price)
		if tax_class == 1 || tax_class == 1.1
			return sprintf('%.2f' % @pwt)
		else
			@pwt = (@pwt * 20.00).ceil / 20.00
			return sprintf('%.2f' % @pwt)
		end
	end

	def tax
		return (price_with_tax.to_f - @price)
	end
end

# Import text file
@p = []
File.foreach('inputs.txt')  do |product| 
	args = product.split(" ")
	@quantity = args.first.to_i
	@price = args.last.to_f
	@name = args[1..-3].join(" ")
	if @name.include?('imported')
		@imported = true
	else
		@imported = false
	end
	if @name.include?('book')
		@category = 'books'
	elsif @name.include?('chocolate')
		@category = 'food'
	elsif @name.include?('pills')
		@category = 'medical'
	else
		@category = 'other'
	end
	@p << Product.new(:name => @name, :price => @price, :quantity => @quantity, :category => @category, :imported => @imported)
end

# Initialize Receipt
class Receipt
	attr_reader :id, :products, :total_tax

	def initialize(args)
		@id = args[:id]
		@products = args[:products]
	end

	def list_products
		@products.each do |p|
			puts p.quantity.to_s + ' ' + p.name + ' : ' + p.price_with_tax.to_s
		end
	end

	def calculate_tax
		@total_tax = 0
		@products.each do |p|
			if p.tax != nil
				@total_tax += p.tax
			end
		end
		@total_tax = sprintf('%.2f' % @total_tax)
		puts 'Sales Taxes : ' + @total_tax.to_s
	end

	def calculate_total
		@total = 0
		@products.each do |p|
			@total += p.price
		end
		@total = @total + @total_tax.to_f
		@total = sprintf('%.2f' % @total)
		puts 'Total : ' + @total.to_s
	end

	def final_output 
		puts 'Output ' + @id + ':'
		list_products
		calculate_tax
		calculate_total
		puts ""
	end
end

output_1 = Receipt.new(:id => "1", :products => [@p[0], @p[1], @p[2]])
output_2 = Receipt.new(:id => "2", :products => [@p[3], @p[4]])
output_3 = Receipt.new(:id => "3", :products => [@p[5], @p[6], @p[7], @p[8]])

output_1.final_output
output_2.final_output
output_3.final_output

