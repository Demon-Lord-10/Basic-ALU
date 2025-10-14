// Black cell for Kogge-Stone
module black_cell (
    input  p_i, g_i, p_j, g_j,
    output p_out, g_out
);
    assign p_out = p_i & p_j;
    assign g_out = g_i | (p_i & g_j);
endmodule

// Gray cell for final stage
module gray_cell (
    input  p_i, g_i, g_j,
    output g_out
);
    assign g_out = g_i | (p_i & g_j);
endmodule

