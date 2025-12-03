async function loadXML(url) {
  const response = await fetch(url);
  const text = await response.text();
  return new DOMParser().parseFromString(text, "application/xml");
}

async function transform() {
  const params = new URLSearchParams(window.location.search);
  const docName = params.get("doc") || "strategic-plan.xml";

  const xml = await loadXML(docName);
  const xsl = await loadXML("render-award-pid.xsl");

  const processor = new XSLTProcessor();
  processor.importStylesheet(xsl);

  // IMPORTANT FIX: transform to *document*, then serialize to HTML
  const doc = processor.transformToDocument(xml);
  const html = new XMLSerializer().serializeToString(doc);

  const container = document.getElementById("content");
  container.innerHTML = html;
}

document.addEventListener("DOMContentLoaded", transform);
