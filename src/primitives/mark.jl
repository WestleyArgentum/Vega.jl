type VegaMark
	# The mark type (:rect, :path, :arc, etc.)
	marktype::Symbol

	# A unique name for the mark instance (optional)
	name::Symbol

	# An optional description of this mark. Can be used as a comment.
	description::String

	# An object describing the data this mark set should visualize
	# The supported properties are data (the name of the data set to use)
	#  and transform (to provide an array of data transformations to apply)
	# If the data property is not defined, the mark will attempt to inherit
	#  data from its parent group mark, if any
	# Otherwise, a default, single element data set is assumed
	from::Dict{Any, Any}

	# An object containing the property set definitions
	properties::VegaMarkProperties

	# A data field to use as a unique key for data binding
	# When a visualization's data is updated, the key value will be used
	#  to match data elements to existing mark instances
	# Use a key field to enable object constancy for transitions over dynamic
	#  data
	# If no key value is provided, the index in the data array is instead
	#  used to match data to mark instances
	key::Symbol

	# The transition delay, in milliseconds, for mark updates
	# The delay can be set in conjunction with the backing data
	#  (possibly through a scale transform) to provide staggered animations
	delay::Int # Needs to dumped as - [ValueRef -> Number]

	# The transition easing function for mark updates
	# The supported easing types are
	# linear, quad, cubic, sin, exp, circle, and bounce,
	# plus the modifiers in, out, in-out, and out-in.
	# The default is cubic-in-out
	ease::String

	# Fill with other stuff????
	marks::Vector{VegaMark}
end

function VegaMark(;marktype::Symbol = :symbol,
	               name::Symbol = :null,
	               description::String = "",
	               from::Dict{Any, Any} = Dict{Any, Any}(),
	               properties::VegaMarkProperties = VegaMarkProperties(),
	               key::Symbol = :null,
	               delay::Int = -1,
	               ease::String = "",
	               marks::Vector{VegaMark} = VegaMark[])
	VegaMark(marktype,
		     name,
		     description,
		     from,
		     properties,
		     key,
		     delay,
		     ease,
		     marks)
end

function tojs(x::VegaMark)
	res = Dict()
	res["type"] = string(x.marktype)
	if !isempty(x.description)
		res["description"] = x.description
	end
	if x.from != nothing
		res["from"] = tojs(x.from)
	end
	if x.properties != nothing
		res["properties"] = tojs(x.properties)
	end
	if x.key != :null
		res["key"] = string(x.key)
	end
	if x.delay != -1
		res["key"] = {"value" => x.delay}
	end
	if !isempty(x.ease)
		res["ease"] = x.ease
	end
	if !isempty(x.marks)
		res["marks"] = [tojs(z) for z in x.marks]
	end
	return res
end

function Base.copy(x::VegaMark)
	VegaMark(x.marktype,
	         x.name,
	         x.description,
	         x.from,
	         copy(x.properties),
	         x.key,
	         x.delay,
	         x.ease,
	         copy(x.marks))
end
