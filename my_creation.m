function population = my_creation(GenomeLength, ~,options)
    pop_size = options.PopulationSize;
    population = zeros(pop_size, GenomeLength);
    for i = 1:pop_size
        while true
            % 生成随机0-1向量
            individual = randi([0 1], 1, GenomeLength);
            if sum(individual) >= 1 % 至少选1个
                population(i, :) = individual;
                break;
            end
        end
    end
end