module FIFO_test;

parameter DATA_WIDTH = 8;
parameter ADDR_WIDTH = 4;

wire                     rst_n;
wire                     clk;
wire                     push;
wire                     pop;
wire [DATA_WIDTH -1 : 0] data_in;
wire [DATA_WIDTH -1 : 0] data_out;
wire                     empty; //flag
wire                     full;  //flag


//instantierea componentei corespunzătoare circuitului testat (DUT)
FIFO #(DATA_WIDTH, ADDR_WIDTH)
DUT_Test (
.rst_n         (rst_n         ),
.clk           (clk           ),
.push          (push          ),
.pop           (pop           ),
.data_in       (data_in       ),
.data_out      (data_out      ),
.empty         (empty         ),
.full          (full          )
);

//instantierea componentei corespunzătoare generatorului de vectori de test
FIFO_Test_Bench #(
.DATA_WIDTH(DATA_WIDTH),
.ADDR_WIDTH(ADDR_WIDTH)
)
DUT_Test_Bench (
.rst_n         (rst_n         ),
.clk           (clk           ),
.push          (push          ),
.pop           (pop           ),
.data_in       (data_in       ),
.empty         (empty         ),
.full          (full          ) 
);
endmodule