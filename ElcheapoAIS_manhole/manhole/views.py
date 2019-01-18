from django.shortcuts import render

import manhole.models
from django.views.decorators.csrf import csrf_exempt
from django.http import HttpResponse

@csrf_exempt
def script(request, client):
    client = manhole.models.Client.objects.get(id=client)
    script = client.latest_script
    content = script.content.replace("\r", "").encode("utf-8")
    response = HttpResponse(content, content_type="text/plain")
    response["Ordering"] = str(script.ordering)
    return response
    
@csrf_exempt
def output(request, client, ordering):
    client = manhole.models.Client.objects.get(id=client)
    script = client.scripts.get(ordering=ordering)
    try:
        output = script.output
    except:
        output = manhole.models.Output()
        output.script = script
    output.content = request.body.decode("utf-8")
    output.save()
    return HttpResponse("Saved")
