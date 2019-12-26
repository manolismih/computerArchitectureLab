function void = make_graphs()
	spec = {"specbzip2" "spechmmer" "speclbm" "specmcf" "specjeng"};

	data = importdata("importdata.txt");
	data = data(:,1);
	for i=1:5
		cpi = data(1 +25*(i-1) : 25*i ,1);
		cpi = [ [cpi(1:3); 0] cpi(4:7) [cpi(8:10); 0] cpi(11:14) [cpi(15:17); 0] cpi(18:21) cpi(22:25) ];
		cpi = transpose(cpi);
		bar(cpi);
		ylabel("CPI");
		title(spec{i});
		set(gca, "XTickLabel", {"Cache line:\n16 32 64", "L1d assoc:\n1 2 4 8", "L1d size:\n32 64 128 KB", "L1i assoc:\n1 2 4 8", "L1i size:\n32 64 128 KB", "L2 assoc:\n1 2 4 8", "L2 size: 512KB\n1 2 4 MB"});
		print(spec{i},"-dsvg");
	end
	close all;
end
