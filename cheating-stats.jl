### A Pluto.jl notebook ###
# v0.12.11

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ f478b22a-2c97-11eb-0fc2-775c801200e5
begin
	import Pkg
	Pkg.add("Distributions")
	Pkg.add("Plots")
	Pkg.add("PlutoUI")
	Pkg.add("StatsBase")

	using Distributions
	using Plots
	using PlutoUI
end

# ╔═╡ 576dcbf4-2ca2-11eb-3eda-6716d2066c94
@bind start_size Slider(60 : 1 : 1000, show_value=true)

# ╔═╡ 6b3d3cb0-2cab-11eb-2ad3-af14d6710358
@bind end_size Slider(60 : 1 : 1000, default=200, show_value=true)

# ╔═╡ ed856a36-2caa-11eb-2582-c5e85e9c78ff
@bind q Slider(0.9 : 0.001 : 0.999, default=0.95, show_value=true)

# ╔═╡ bfff398c-2ca2-11eb-17ba-ed0374d0ec62
md"""
# Let's do a simulation! 

Let's say that there are some folks who cheat a little bit while doing research. Normally you would collect a set of data and then you'd perform a hypothesis test. You'd check how likely a result might be by saying that the probability of getting this result is less than `prob`=$(round(1-q, digits=4)). If this is the case you'd claim that there's statistical significance to your finding. 

Let's now say we're going to be cheating. We're going to add new data if we can't claim significance. Each time we add a new datapoint we'd check if we can claim significance. If not, we'll just continue making our dataset bigger! This would give you many more moments to claim significance while you'd still being able to demonstrate that you've cross a statistical threshold! 

This is obviously cheating the test, but in this notebook we're going to see to what extend you're able to cheat.

## Simulation Variables
"""

# ╔═╡ e88e92dc-2caa-11eb-22fb-893cfe75027c
md"""Let's assume that we start out with a group of size $start_size. We'll assume a statistical threshold at the $q quantile and the group size keeps increasing until we get tired. After seeing a population of size $end_size we'll call it quites. During the entire simulation we'll assume that we're flipping a coin and that we're testing that the coin is biased."""

# ╔═╡ 1a6897f0-2cae-11eb-1599-6d5bfc2b4bb9
@bind go Button("Re-Run!")

# ╔═╡ 224e688e-2c98-11eb-155d-5d0263dc4587
begin
	# Let's precompute some values to save time.
	threshold = Dict((n) => quantile(Binomial(n, 0.5), q) for n in 1:1000);
	
	function simulate(min_n, max_n)
		n = min_n
		s = sum(rand(0:1, n))
		while n < max_n
			if s >= threshold[n]
				return n
			end 
			n += 1 
			s += rand(0:1)
		end
		return n
	end;
	go
	data = [simulate(start_size, end_size) for i in 1:200000]
end;

# ╔═╡ c2a0f78a-2ca1-11eb-0baa-93e173c4b150
histogram(data, bins=50, title="When do we stop counting?")

# ╔═╡ 90c44f78-2ca6-11eb-3d7a-01f85f4f2770
begin
	first_group = mean(data .== start_size)
	all_groups = mean(data .!= end_size)
end;

# ╔═╡ cb9cf888-2cac-11eb-3446-db7f1e1caa5a
md"""
Under these circumstances it seems like $all_groups percent of the time you can claim significance while collecting just the first group only yields $first_group. This data is simulated. You can press the button below to rerun everything.
"""

# ╔═╡ Cell order:
# ╟─f478b22a-2c97-11eb-0fc2-775c801200e5
# ╟─bfff398c-2ca2-11eb-17ba-ed0374d0ec62
# ╟─576dcbf4-2ca2-11eb-3eda-6716d2066c94
# ╟─6b3d3cb0-2cab-11eb-2ad3-af14d6710358
# ╟─ed856a36-2caa-11eb-2582-c5e85e9c78ff
# ╟─e88e92dc-2caa-11eb-22fb-893cfe75027c
# ╟─224e688e-2c98-11eb-155d-5d0263dc4587
# ╟─c2a0f78a-2ca1-11eb-0baa-93e173c4b150
# ╟─90c44f78-2ca6-11eb-3d7a-01f85f4f2770
# ╟─cb9cf888-2cac-11eb-3446-db7f1e1caa5a
# ╟─1a6897f0-2cae-11eb-1599-6d5bfc2b4bb9
