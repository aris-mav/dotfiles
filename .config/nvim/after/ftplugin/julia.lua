if vim.g.did_after_julia then
  return
end
vim.g.did_after_julia = true

-- choose lsp using the $JULIALSP environment variable
if os.getenv("JULIALSP") == "jetls" then
    vim.lsp.config("jetls", {
        cmd = {
            "jetls",
            "--threads=auto",
            "--",
        },
        filetypes = {"julia"},
    })
    vim.lsp.enable("jetls")

elseif os.getenv("JULIALSP") == "julials" then

    if vim.fn.isdirectory(vim.fn.expand("~/.julia/environments/nvim-lspconfig")) ~= 1
        and vim.fn.executable("julia") == 1 then
        print("Installing LanguageServer.jl")
        vim.fn.system('julia --project=~/.julia/environments/nvim-lspconfig -e "using Pkg; Pkg.add(\\"LanguageServer\\"); Pkg.add(\\"SymbolServer\\"); Pkg.add(\\"StaticLint\\")"')
    end

    local v = vim.version()
    if not ((v.major > 0) or (v.major == 0 and v.minor >= 11)) then
        -- the config below should be unncessary in versions above 0.11, according to 
        -- https://github.com/julia-vscode/LanguageServer.jl/wiki/Vim-and-Neovim
        vim.lsp.config('julials', {
            cmd = {
                "julia",
                "--project=".."~/.julia/environments/nvim-lspconfig/",
                "--startup-file=no",
                "--history-file=no",
                vim.fn.expand("~/.config/nvim/lua/lsp/") .. "julials_start.jl"
            },
            filetypes = { 'julia' },
            root_markers = { "Project.toml", "JuliaProject.toml" },
            settings = {}
        })
    end

    vim.lsp.enable("julials")
end
