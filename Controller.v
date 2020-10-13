module Controller(clk, rst, A_Police, B_Police, A_Traffic, B_Traffic, Time, A_Light, B_Light);

input clk, rst, A_Police, B_Police, A_Traffic, B_Traffic;
output Time, A_Light, B_Light;

// wire [6:0]counter_number;

reg [6:0]t = 7'd90;
reg al = 1'b1;
reg bl = 1'b0;

// reg waiting_mode = 0;

assign A_Light = al;
assign B_Light = bl;
assign Time = t;

reg police_mode = 0;
reg [3:0]traffic = 0;

always @(posedge clk) begin
	if (rst) begin
		// reset
		t = 7'd90;
		al = 1'b1;
		bl = 1'b0;
		police_mode = 0;
		traffic = 0;
	end
	else
		if (A_Police) begin
			// 100 is equivalent to PO
			t = 7'd100;
			al = 1;
			bl = 0;
			police_mode = 1;
		end
		else if (B_Police) begin
			// 100 is equivalent to PO
			t = 7'd100;
			al = 0;
			bl = 1;
			police_mode = 1;
		end

		// Automatic mode
		if (police_mode == 0) begin
			if (al) begin
				// A has traffic
				if (A_Traffic) begin
					traffic = traffic + 1;
				end
				else begin
					traffic = 0;
				end
				if (traffic < 4'd10) begin
					t = t - 1;
				end
			end
			else if (bl) begin
				if (B_Traffic) begin
					traffic = traffic + 1;
				end
				else begin
					traffic = 0;
				end
				if (traffic < 4'd10) begin
					t = t - 1;
				end
			end
			if (t == 0) begin
				if (al) begin
					al = 0;
					// wait for 5secs
					#5
					t = 7'd30;
					// b ro sabz kon
					bl = 1;
				end
				else if (bl) begin
					bl = 0;
					// wait for 5secs
					#5
					t = 7'd90;
					// a ro sabz kon
					al = 1;
				end
			end	
		end

end

endmodule

module Traffic_TB;

wire Time;
wire A_Light;
wire B_Light;

reg A_Police, B_Police, A_Traffic, B_Traffic;
reg clk, rst;

Controller test_controller(clk, rst, A_Police, B_Police, A_Traffic, B_Traffic, Time, A_Light, B_Light);

initial
begin
	rst = 0;
	A_Traffic = 1;

	#60 A_Traffic = 0;
end

// Doing clock shit
initial
begin
	clk = 0;

	forever
	#1 clk = ~clk;
end

endmodule

module Police_TB;

wire Time;
wire A_Light;
wire B_Light;

reg A_Police, B_Police, A_Traffic, B_Traffic;
reg clk, rst;

Controller test_controller(clk, rst, A_Police, B_Police, A_Traffic, B_Traffic, Time, A_Light, B_Light);

initial
begin
	rst = 0;
	A_Police = 0;
	B_Police = 0;
	A_Traffic = 0;
	B_Traffic = 0;

	#60 B_Police = 1;
	#10 B_Police = 0;
	rst = 1;
	#5 rst = 0;
end

// Doing clock shit
initial
begin
	clk = 0;

	forever
	#1 clk = ~clk;
end
endmodule

module General_TB;

wire Time;
wire A_Light;
wire B_Light;

reg A_Police, B_Police, A_Traffic, B_Traffic;
reg clk, rst;

Controller test_controller(clk, rst, A_Police, B_Police, A_Traffic, B_Traffic, Time, A_Light, B_Light);

initial
begin
	rst = 0;
	A_Police = 0;
	B_Police = 0;
	A_Traffic = 0;
	B_Traffic = 0;
end

// Doing clock shit
initial
begin
	clk = 0;

	forever
	#1 clk = ~clk;
end
endmodule
