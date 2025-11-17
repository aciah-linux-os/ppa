#!/usr/bin/env python3
# Auteur : association ACIAH - novembre 2025
# licence : GPL V3
# rôle : compresser un document pdf avec Ghostscript
# vérifier que Ghostscript est bien installé

import subprocess
import argparse

def compress_pdf_with_ghostscript(input_path, output_path, quality):
    """ 
    Args:
        input_path (str): chemin du fichier PDF à compresser.
        output_path (str): chemin du fichier PDF compressé.
        quality (str): niveau de compression ('screen', 'ebook', 'printer', 'prepress').
    """
    gs_command = [
        'gs', '-sDEVICE=pdfwrite',
        '-dCompatibilityLevel=1.4',
        f'-dPDFSETTINGS=/{quality}',
        '-dNOPAUSE', '-dQUIET', '-dBATCH',
        f'-sOutputFile={output_path}',
        input_path
    ]
    subprocess.call(gs_command)

def main():
    parser = argparse.ArgumentParser(description="Compresse un PDF avec Ghostscript")
    parser.add_argument("input_file", help="Chemin du fichier PDF à compresser")
    parser.add_argument("-q", "--quality", choices=['screen', 'ebook', 'printer', 'prepress'], default='screen',
                        help="Qualité de compression (par défaut: screen)")
    args = parser.parse_args()

    output_file = args.input_file.rsplit('.', 1)[0] + '-compress.pdf'
    compress_pdf_with_ghostscript(args.input_file, output_file, args.quality)
    print(f"Fichier compressé sauvegardé sous : {output_file}")

if __name__ == "__main__":
    main()

import subprocess
import argparse

def compress_pdf_with_ghostscript(input_path, output_path, quality):
    """
    Compresse un fichier PDF avec Ghostscript.
    
    Args:
        input_path (str): chemin du fichier PDF à compresser.
        output_path (str): chemin du fichier PDF compressé.
        quality (str): niveau de compression ('screen', 'ebook', 'printer', 'prepress').
    """
    gs_command = [
        'gs', '-sDEVICE=pdfwrite',
        '-dCompatibilityLevel=1.4',
        f'-dPDFSETTINGS=/{quality}',
        '-dNOPAUSE', '-dQUIET', '-dBATCH',
        f'-sOutputFile={output_path}',
        input_path
    ]
    subprocess.call(gs_command)

def main():
    parser = argparse.ArgumentParser(description="Compresse un PDF avec Ghostscript")
    parser.add_argument("input_file", help="Chemin du fichier PDF à compresser")
    parser.add_argument("-q", "--quality", choices=['screen', 'ebook', 'printer', 'prepress'], default='screen',
                        help="Qualité de compression (par défaut: screen)")
    args = parser.parse_args()

    output_file = args.input_file.rsplit('.', 1)[0] + '-compress.pdf'
    compress_pdf_with_ghostscript(args.input_file, output_file, args.quality)
    print(f"Fichier compressé sauvegardé sous : {output_file}")

if __name__ == "__main__":
    main()
