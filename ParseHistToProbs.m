function prob = ParseHistToProbs(uniques,values)

prob=zeros(size(uniques));
parfor i = 1:size(uniques,2)
prob(i) = sum(values==uniques(i))/numel(values);
end

end