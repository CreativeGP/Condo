
<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8"/>
        <title>The Condo Programming Language</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.13.1/styles/default.min.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.13.1/highlight.min.js"></script>
        <script>hljs.initHighlightingOnLoad();</script>

        
        <style>
         blockquote {
             background: none;
             border-left: 3px solid #777;
             color: #777;
             margin: 20px 0;
             padding: 0 0 0 10px;
         }
         table {
             border-width: 1px 0 0 1px;
             border-color: #bbb;
             border-style: solid;
         }

         table td, table th {
             border-width: 0 1px 1px 0;
             border-color: #bbb;
             border-style: solid;
             padding: 10px;
         }
        </style>
    </head>
    <body>
        <div class="container">
            <a href="index"><h1>Condo</h1></a>
        </div>
        <hr/>

        <div class="container">
            <?php

            include_once "vendor/autoload.php";
            $Parsedown = new Parsedown();
            $contents = @file_get_contents("contents/".basename($_SERVER['REQUEST_URI'], '?' . $_SERVER['QUERY_STRING']).".md");
            if ($contents == "")
                $contents = @file_get_contents("contents/index.md");
            echo $Parsedown->text($contents);

            ?>
            
        </div>
        
    </body>
</html>
