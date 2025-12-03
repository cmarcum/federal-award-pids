async function loadXML(url) {
  const response = await fetch(url);
  const text = await response.text();
  const parser = new DOMParser();
  return parser.parseFromString(text, "application/xml");
}

async function transform() {
  const params = new URLSearchParams(window.location.search);
  const docName = params.get("doc") || "strategic-plan.xml";

  const xml = await loadXML(docName);
  const xsl = await loadXML("render-award-pid.xsl");

  const processor = new XSLTProcessor();
  processor.importStylesheet(xsl);

  const result = processor.transformToFragment(xml, document);
  const container = document.getElementById("content");
  container.innerHTML = "";
  container.appendChild(result);
}

document.addEventListener("DOMContentLoaded", transform);
