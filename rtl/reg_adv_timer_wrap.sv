//
// Advanced Timer Wrap
//
// Authors:
// Nico Canzani <ncanzani@student.ethz.ch>
//
// Description: This wrapper adapts the flat interface of apb_adv_timer to
//              the Regbus interface. Note that your Regbus must have
//              a datawidth of 32 to match the IP.
//
// This code is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.
//
// This code is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the
// Free Software  Foundation, Inc., 59 Temple Place, Suite 330,
// Boston, MA  02111-1307  USA
//

`include "apb/typedef.svh"

module reg_adv_timer_wrap #(
    parameter int unsigned AddrWidth = 32,
    parameter type reg_req_t = logic,
    parameter type reg_rsp_t = logic
) (
  input  logic clk_i,
  input  logic rst_ni,

  // Regbus
  input  reg_req_t reg_req_i,
  output reg_rsp_t reg_rsp_o,

  // Physical interface
  input  logic dft_cg_enable_i,
  input  logic low_speed_clk_i,
  input  logic [31:0] ext_sig_i,
  output logic [3:0] events_o,
  output logic [3:0] ch_0_o,
  output logic [3:0] ch_1_o,
  output logic [3:0] ch_2_o,
  output logic [3:0] ch_3_o
);
  `APB_TYPEDEF_REQ_T(reg_adv_timer_apb_req_t, logic [AddrWidth-1:0], logic [31:0], logic [3:0])
  `APB_TYPEDEF_RESP_T(reg_adv_timer_apb_rsp_t, logic [31:0])

  reg_adv_timer_apb_req_t adv_timer_apb_req;
  reg_adv_timer_apb_rsp_t adv_timer_apb_rsp;

  reg_to_apb #(
    .reg_req_t  ( reg_req_t             ),
    .reg_rsp_t  ( reg_rsp_t             ),
    .apb_req_t  ( reg_adv_timer_apb_req_t    ),
    .apb_rsp_t  ( reg_adv_timer_apb_rsp_t    )
  ) i_reg_adv_timer_reg_to_apb (
    .clk_i,
    .rst_ni,
    .reg_req_i,
    .reg_rsp_o,
    .apb_req_o  ( adv_timer_apb_req          ),
    .apb_rsp_i  ( adv_timer_apb_rsp          )
  );

  apb_adv_timer i_apb_adv_timer (
  .HCLK             ( clk_i   ),
  .HRESETn          ( rst_ni  ),
  .PADDR            ( adv_timer_apb_req.paddr[4:2]  ),
  .PWDATA           ( adv_timer_apb_req.pwdata      ),
  .PWRITE           ( adv_timer_apb_req.pwrite          ),
  .PSEL             ( adv_timer_apb_req.psel            ),
  .PENABLE          ( adv_timer_apb_req.penable         ),
  .PRDATA           ( adv_timer_apb_rsp.prdata      ),
  .PREADY           ( adv_timer_apb_rsp.pready      ),
  .PSLVERR          ( adv_timer_apb_rsp.pslverr     ),

  .dft_cg_enable_i  ( dft_cg_enable_i ),
  .low_speed_clk_i  ( low_speed_clk_i ),
  .ext_sig_i        ( ext_sig_i ),

  .events_o         ( events_o ),

  .ch_0_o           ( ch_0_o ),
  .ch_1_o           ( ch_1_o ),
  .ch_2_o           ( ch_2_o ),
  .ch_3_o           ( ch_3_o )
);

endmodule