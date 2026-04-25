import os
import sys
import pytesseract
import fitz  # PyMuPDF
from PIL import Image

# Cerca Tesseract nei percorsi di installazione predefiniti
tesseract_paths = [
    r"C:\Program Files\Tesseract-OCR\tesseract.exe",
    r"C:\Program Files (x86)\Tesseract-OCR\tesseract.exe",
    os.path.expandvars(r"%LOCALAPPDATA%\Tesseract-OCR\tesseract.exe")
]

tess_found = False
for p in tesseract_paths:
    if os.path.exists(p):
        pytesseract.pytesseract.tesseract_cmd = p
        tess_found = True
        print(f"Tesseract trovato in: {p}")
        break

if not tess_found:
    print("Errore: Impossibile trovare tesseract.exe installato nel sistema.")
    sys.exit(1)

def scan_pdf(pdf_path, output_path, max_pages=5):
    if not os.path.exists(pdf_path):
        print(f"Errore: File non trovato {pdf_path}")
        return
    
    print(f"Apertura del PDF: {pdf_path}")
    try:
        doc = fitz.open(pdf_path)
    except Exception as e:
        print(f"Errore durante l'apertura del PDF: {e}")
        return
        
    extracted_text = ""
    
    pages_to_process = min(len(doc), max_pages) 
    print(f"Estrazione testo tramite OCR (max {pages_to_process} pagine per preview)...")

    for i in range(pages_to_process):
        print(f"Elaborazione pagina {i+1}/{len(doc)}...")
        page = doc.load_page(i)
        
        # Rendering della pagina come immagine a DPI 200 per favorire l'OCR
        pix = page.get_pixmap(dpi=200)
        
        try:
            # Crea un oggetto immagine PIL
            img = Image.frombytes("RGB", [pix.width, pix.height], pix.samples)
            
            # Esegui OCR (usiamo eng e/o ita se disponibile)
            text = pytesseract.image_to_string(img)
            extracted_text += f"\n--- Pagina {i+1} ---\n{text}\n"
        except Exception as e:
            print(f"Errore durente l'OCR della pagina {i+1}: {e}")

    # Salva il risultato testuale
    try:
        with open(output_path, "w", encoding="utf-8") as f:
            f.write(extracted_text)
        print(f"Estrazione completata CON SUCCESSO. Testo salvato in: {output_path}")
    except Exception as e:
        print(f"Errore durante il salvataggio del file estratto: {e}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Uso: python pdf_scanner.py <input.pdf> <output.txt> [max_pages]")
        sys.exit(1)
    
    input_pdf = sys.argv[1]
    out_txt = sys.argv[2]
    m_p = int(sys.argv[3]) if len(sys.argv) > 3 else 5
    scan_pdf(input_pdf, out_txt, m_p)
