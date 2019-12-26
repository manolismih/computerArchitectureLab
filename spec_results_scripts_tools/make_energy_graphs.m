function void = make_energy_graphs()
	yAxisLabel = {"" "'Peak Power (W)'" "'Area (mm^2)'"};
	initialData = importdata("importdataEDAP.txt");
	for graph=2:3
		data = initialData(1:25,graph);
		data = [ [data(1:3); 0] data(4:7) [data(8:10); 0] data(11:14) [data(15:17); 0] data(18:21) data(22:25) ];
		data = transpose(data);
		bar(data);
		ylabel(yAxisLabel{graph});
		set(gca, "XTickLabel", {"Cache line:\n16 32 64", "L1d assoc:\n1 2 4 8", "L1d size:\n32 64 128 KB", "L1i assoc:\n1 2 4 8", "L1i size:\n32 64 128 KB", "L2 assoc:\n1 2 4 8", "L2 size: 512KB\n1 2 4 MB"});
		print(yAxisLabel{graph},"-dsvg");
	end
	close all;
end
