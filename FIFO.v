module FIFO #(
parameter DATA_WIDTH = 8,
parameter ADDR_WIDTH = 4
)
(
input                          rst_n    ,
input                          clk      ,
input                          push     ,
input                          pop      ,
input      [DATA_WIDTH -1 : 0] data_in  ,
output reg [DATA_WIDTH -1 : 0] data_out ,
output reg                     empty    , //flag
output reg                     full       //flag
);

reg [ADDR_WIDTH -1 : 0] fifo_counter                  ; //sau 7 biti
reg [ADDR_WIDTH -1 : 0] tail                          ; //pointer
reg [ADDR_WIDTH -1 : 0] head                          ; //pointer
reg [DATA_WIDTH -1 : 0] memory[(1<<ADDR_WIDTH) -1:0]  ; //memorie de 2^ADDR_WIDTH x DATA_WIDTH

//Status flag
always@(fifo_counter) //mereu cand fifo_counter se schimba, verificam daca fifo e gol sau plin
begin
	empty = (fifo_counter == 0 ); //flag-ul empty = 1 (e HIGH); nu e nimic in FIFO; nu se poate citi din FIFO
	full  = (fifo_counter == (1<<ADDR_WIDTH) - 1); //flag-ul full = 1 (e HIGH); nu mai e spatiu in FIFO; nu se poate scrie in FIFO
end

//Functionare fifo_counter
always@(posedge clk or posedge rst_n) 
begin
	if (rst_n) //reset activ pe HIGH
		fifo_counter <= 0;            //reset activ => resetam fifo_counter
	else if ((!full && push) && (!empty && pop))
		fifo_counter <= fifo_counter;
	else if (!full && push)           //daca putem sa scriem
		fifo_counter <= fifo_counter + 1;
	else if (!empty && pop)           //daca putem sa citim
		fifo_counter <= fifo_counter - 1;
	else
		fifo_counter <= fifo_counter; //daca nu putem nici sa scriem, nici sa citim, nu modificam nimic
end

//preluare date din FIFO
always@(posedge clk or posedge rst_n) 
if (rst_n)			data_out <= 0; else       //daca resetam, la iesire avem 0 else begin
if (pop && !empty) 	data_out <= memory[tail]; //citim la iesire valorea din "coada" memoriei


//scriere date in FIFO
always@(posedge clk) 
begin
	if (push && !full)                 //daca putem sa scriem
		memory[head] <= data_in;       //punem data in "capatul" memoriei
	else
		memory[head] <= memory[head];  //pastram datele cum sunt
end

//pozitiile "capat" si "coada"
always@(posedge clk or posedge rst_n)
begin
	if(rst_n)
		begin
			head <= 0; //0 by default
			tail <= 0; //0 by default
		end
	else
		begin
			if(!full && push)     //daca scriem in memorie
				head <= head + 1; //incrementam "capatul" memoriei
			else
				head <= head; 
			if(!empty && pop)     //daca citim din memorie
				tail <= tail + 1; //incrementam "coada" memoriei
			else
				tail <= tail;
		end
	// "coada" merge numai dupa "capat", nu o poate lua inainte
end

endmodule
	