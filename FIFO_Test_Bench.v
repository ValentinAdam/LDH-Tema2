module FIFO_Test_Bench #(
parameter DATA_WIDTH = 8,
parameter ADDR_WIDTH = 4
)
(
output reg                      rst_n    ,
output reg                      clk	     ,
output reg                      push	 ,
output reg                      pop	     ,
output reg [DATA_WIDTH -1 : 0]  data_in  ,
input                           empty    , //flag
input                           full       //flag
);

wire [DATA_WIDTH -1 : 0] data_out      ;
wire [DATA_WIDTH -1 : 0] fifo_counter  ;  //sau 7 biti
wire [ADDR_WIDTH -1 : 0] tail          ;  //pointer
wire [ADDR_WIDTH -1 : 0] head          ;  //pointer


initial begin 
	clk      <= 0;
	forever #8 clk <= ~clk;  //intotdeauna, la 8 unitati de timp, semnalul de ceas isi schimba starea
end

initial begin 
	rst_n    <= 0;
	@(posedge clk);
	rst_n    <= 1;
	@(posedge clk);
	@(posedge clk);
	rst_n    <= 0;
	@(posedge clk);
end

initial begin 
	push     <= 1'bx;
	data_in  <= 'bx;
	@(posedge rst_n);
	push     <= 1'b0;
	data_in  <= 'bx;
	@(negedge rst_n);
	@(posedge clk);

//	repeat (10) begin
//		push     <= 1'b1;
//		data_in <= $random;
//		@(posedge clk);
//		push     <= 1'b0;
//		data_in  <= 'bx;
//		@(posedge clk);
//	end

	forever begin
		while (full) @(posedge clk);
		  push     <= 1'b1;
		  data_in <= $random;
		  @(posedge clk);
		  push     <= 1'b0;
		  data_in  <= 'bx;
          @(posedge clk);
	end
end

initial begin 
	pop     <= 1'bx;
	@(posedge rst_n);
	pop     <= 1'b0;
	@(negedge rst_n);
	repeat (5) @(posedge clk);

//	repeat (50) @(posedge clk);
//	// push-uri
//	
//	repeat (10) begin
//		pop     <= 1'b1;
//		@(posedge clk);
//		pop     <= 1'b0;
//		@(posedge clk);
//	end

	while (~full) @(posedge clk);
	
	forever begin
		while (empty) @(posedge clk);
		pop     <= 1'b1;
		@(posedge clk);
		pop     <= 1'b0;
        @(posedge clk);
	end
//	$display("Final");
//	$stop;
end

endmodule