function new_data = gen_new_data( old_data, last_year, future_years )
    gen_years=((last_year+1):(last_year+future_years))';
    mean_var_diff=sum(diff(old_data))/length(old_data);
    new_data=old_data(end)+mean_var_diff*(gen_years-gen_years(1)+1);
end

