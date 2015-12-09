<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PreviewFile.aspx.vb" Inherits="IntranetPortal.PreviewFile" %>

<html>
<body>
  <canvas id="the-canvas" style="border:1px  solid black"></canvas>

  <!-- Use latest PDF.js build from Github -->
  <script src="http://mozilla.github.io/pdf.js/build/pdf.js"></script>
  
  <script>
      //
      // NOTE:
      // Modifying the URL below to another server will likely *NOT* work. Because of browser
      // security restrictions, we have to use a file server with special headers
      // (CORS) - most servers don't support cross-origin browser requests.
      //http://localhost:54528/DownloadFile.aspx?id=26
      var url = 'http://localhost:54528/DownloadFile.aspx?id=26';
      window.open("/pdfViewer/web/viewer.html?file=" + encodeURIComponent(url), "_blank");

      //
      // Disable workers to avoid yet another cross-origin issue (workers need the URL of
      // the script to be loaded, and dynamically loading a cross-origin script does
      // not work)
      //
      PDFJS.disableWorker = true;

      //
      // Asynchronous download PDF
      //
      PDFJS.getDocument(url).then(function getPdfHelloWorld(pdf) {
          //
          // Fetch the first page
          //
          pdf.getPage(1).then(function getPageHelloWorld(page) {
              var scale = 1;
              var viewport = page.getViewport(scale);

              //
              // Prepare canvas using PDF page dimensions
              //
              var canvas = document.getElementById('the-canvas');
              var context = canvas.getContext('2d');
              canvas.height = viewport.height;
              canvas.width = viewport.width;

              //
              // Render PDF page into canvas context
              //
              page.render({ canvasContext: context, viewport: viewport });
          });
      });
  </script>
  
</body>
</html>
