function [best_fitness, elite, generation] = my_ga(number_of_variables, fitness_function, ...
    population_size, parent_number, mutation_rate, maximal_generation, minimal_cost)
%%% Number of variables:1*1 integer,number of variables in the target function 
%%% Fitness_function: Fitness function written by user
%%% Population_size: The total number of population(incluse parents and children)
%%% mutation_rate: the probability of mutation
%%% maximal_generation: The maximum step of the iteration
%%% minimal_cost: The threshold of the fitness funtion

cumulative_probabilities = cumsum((parent_number:-1:1) / sum(parent_number:-1:1));
best_fitness = ones(maximal_generation, 1);
elite = zeros(maximal_generation, number_of_variables);
child_number = population_size - parent_number;
population = rand(population_size, number_of_variables); % values in [0, 1]
%Create the population
for generation = 1 : maximal_generation
    cost = feval(fitness_function, population);
    %Calculate the fitness function value for every entity
    [cost, index] = sort(cost);
    %Sort the fitness function and recognise the index
    population = population(index(1:parent_number), :);
    %Select 10 minimum fitness value for parents  
    best_fitness(generation) = cost(1);
    %The best fitness is selected as the current minimum
    elite(generation, :) = population(1, :);
    %The elite is selected as the entity that reaches minimum
    if best_fitness(generation) < minimal_cost; break; end
    for child = 1:2:child_number % crossover
        mother = min(find(cumulative_probabilities > rand));
        father = min(find(cumulative_probabilities > rand));
        %The parents that have lower fitness function value
        %have higher probabilities to reproduct
        crossover_point = ceil(rand*number_of_variables);
        %The point to crossover(from 1 to 10)
        mask1 = [ones(1, crossover_point), zeros(1, number_of_variables - crossover_point)];
        mask2 = not(mask1);
        mother_1 = mask1 .* population(mother, :);
        mother_2 = mask2 .* population(mother, :);
        father_1 = mask1 .* population(father, :);
        father_2 = mask2 .* population(father, :);
        %The crossover procedure
        population(parent_number + child, :) = mother_1 + father_2;
        population(parent_number+child+1, :) = mother_2 + father_1;
        %The crossover produces two descendants
    end
    % mutation
    mutation_population = population(2:population_size, :);
    %The first row is considered as the elite who cannot be changed by
    %mutation
    number_of_elements = (population_size - 1) * number_of_variables;
    number_of_mutations = ceil(number_of_elements * mutation_rate);
    %number of positions that have mutation 
    mutation_points = ceil(number_of_elements * rand(1, number_of_mutations));
    %Positions of mutation points
    mutation_population(mutation_points) = rand(1, number_of_mutations);
    population(2:population_size, :) = mutation_population;
end